using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Domain.Consultas.Repositories;

public interface IConsultaRepository
{
    Task AdicionarAsync(Consulta consulta);
    Task AtualizarAsync(Consulta consulta);
    Task<Consulta?> ObterPorIdAsync(Guid id);
    Task<List<Consulta>> ListarAsync();

    Task<List<Consulta>> ObterPorVeterinarioAsync(Guid veterinarioId);

    Task<List<Consulta>> ObterPorPetAsync(Guid petId);

    Task<bool> ExisteConsultaNoHorarioAsync(Guid veterinarioId, DateTime dataConsulta);

    Task<List<Consulta>> ListarFuturasPorPetAsync(Guid petId);

    Task<List<Consulta>> ObterPorVeterinarioEPeriodoAsync(
        Guid veterinarioId,
        DateTime inicio,
        DateTime fim);

    Task<List<Consulta>> ObterEncerradasAsync();
}