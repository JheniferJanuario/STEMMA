using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.Prontuarios.UseCases;

public class GetProntuarioByConsultaIdUseCase
{
    private readonly IProntuarioRepository _repository;

    public GetProntuarioByConsultaIdUseCase(
        IProntuarioRepository repository)
    {
        _repository = repository;
    }

    public async Task<object> ExecuteAsync(Guid consultaId)
    {
        var prontuario =
            await _repository.ObterPorConsultaIdAsync(consultaId);

        if (prontuario is null)
            throw new Exception("Prontuário não encontrado.");

        return new
        {
            prontuario.Id,
            prontuario.ConsultaId,
            prontuario.Observacoes,
            prontuario.Diagnostico,
            prontuario.Tratamento,
            prontuario.Medicacao,
            prontuario.Peso,
            prontuario.DataRegistro
        };
    }
}