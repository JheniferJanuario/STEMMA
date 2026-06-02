using STEMMA.Application.Consultas.DTOs.Requests;
using STEMMA.Application.Consultas.DTOs.Responses;
using STEMMA.Domain.Consultas.Repositories;

public class UpdateConsultationUseCase
{
    private readonly IConsultaRepository _consultaRepository;
    private readonly IDisponibilidadeRepository _disponibilidadeRepository;

    public UpdateConsultationUseCase(
        IConsultaRepository consultaRepository,
        IDisponibilidadeRepository disponibilidadeRepository)
    {
        _consultaRepository = consultaRepository;
        _disponibilidadeRepository = disponibilidadeRepository;
    }

public async Task<ConsultationResponse> ExecuteAsync(Guid id, UpdateConsultationRequest request)
{
    var consulta = await _consultaRepository.ObterPorIdAsync(id);

    if (consulta == null)
        throw new Exception("Consulta não encontrada");

    var disponibilidades = await _disponibilidadeRepository
        .ObterPorVeterinarioAsync(request.VeterinarianId);

    var estaDisponivel = disponibilidades.Any(d =>
        request.DateTime >= d.DataInicio &&
        request.DateTime <= d.DataFim);

    if (!estaDisponivel)
        throw new Exception("Veterinário não está disponível neste horário");

    consulta.AlterarHorario(request.DateTime);
    consulta.AlterarVeterinario(request.VeterinarianId);

    await _consultaRepository.AtualizarAsync(consulta);

    return new ConsultationResponse
    {
        Id = consulta.Id,
        PetId = consulta.PetId,
        VeterinarianId = consulta.VeterinarioId,
        DateTime = consulta.DataConsulta,
        Status = consulta.Status.ToString()
    };
}
}